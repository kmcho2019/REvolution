module TopModule (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  in,
    output reg         done
);

    reg [1:0] byte_count; // Counts bytes in current message: 0=no message, 1=byte1, 2=byte2, 3=byte3

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default de-assert done each cycle

            if (byte_count == 0) begin
                // Waiting for first byte: check in[3]
                if (in[3] == 1'b1) begin
                    byte_count <= 2'd1;
                end
            end else if (byte_count < 3) begin
                // Inside a message: check if current byte has in[3]=1 (start of new message)
                if (in[3] == 1'b1) begin
                    // New message start detected prematurely, restart counter
                    byte_count <= 2'd1;
                end else begin
                    byte_count <= byte_count + 1'b1;
                end
            end else begin
                // byte_count == 3: just received third byte last cycle
                done <= 1'b1;    // Signal done this cycle
                // Prepare to wait for next message
                if (in[3] == 1'b1) begin
                    // Next byte starts a new message immediately
                    byte_count <= 2'd1;
                end else begin
                    byte_count <= 2'd0;
                end
            end
        end
    end

endmodule