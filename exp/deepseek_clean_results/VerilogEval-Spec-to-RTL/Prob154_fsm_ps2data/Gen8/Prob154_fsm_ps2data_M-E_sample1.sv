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
    assign done = (byte_counter == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            collecting <= 1'b0;
        end else begin
            if (!collecting) begin
                // Wait for start byte
                if (in[3]) begin
                    collecting <= 1'b1;
                    byte_counter <= 2'b01;
                    out_bytes <= {in, 16'b0};  // Initialize with first byte
                end
            end else begin
                // Shift in new bytes
                out_bytes <= {out_bytes[15:0], in};
                
                // Update counter
                if (byte_counter == 2'b10) begin
                    // Message complete
                    byte_counter <= 2'b00;
                    collecting <= 1'b0;
                end else begin
                    byte_counter <= byte_counter + 1'b1;
                end
            end
        end
    end

endmodule