module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [1:0] byte_counter;
    reg collecting;

    // Combinational done signal
    assign done = (byte_counter == 2'b10) && collecting;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            collecting <= 1'b0;
        end else begin
            if (collecting) begin
                // Capture current byte in appropriate position
                case (byte_counter)
                    2'b00: out_bytes[23:16] <= in;
                    2'b01: out_bytes[15:8] <= in;
                    2'b10: out_bytes[7:0] <= in;
                endcase

                // Update counter
                byte_counter <= byte_counter + 1;

                // Stop collecting after 3 bytes
                if (byte_counter == 2'b10)
                    collecting <= 1'b0;
            end
            else if (in[3]) begin
                // Start collecting when we see in[3]=1
                collecting <= 1'b1;
                byte_counter <= 2'b00;
                out_bytes[23:16] <= in;  // Capture first byte immediately
            end
        end
    end

endmodule