module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    reg collecting;  // 1-bit state: 0=idle, 1=collecting
    reg [1:0] byte_count;  // Counts 0-2 for 3 bytes
    reg [23:0] shift_reg;

    // Combinatorial done signal
    assign done = (byte_count == 2'b10) && collecting;
    assign out_bytes = done ? shift_reg : 24'bx;

    always @(posedge clk) begin
        if (reset) begin
            collecting <= 1'b0;
            byte_count <= 2'b00;
            shift_reg <= 24'bx;
        end else begin
            if (collecting) begin
                // Shift in new byte
                shift_reg <= {shift_reg[15:0], in};
                
                // Update byte counter
                if (byte_count == 2'b10) begin
                    // Message complete, return to idle
                    collecting <= 1'b0;
                    byte_count <= 2'b00;
                end else begin
                    byte_count <= byte_count + 1'b1;
                end
            end else if (in[3]) begin
                // Start new message collection
                collecting <= 1'b1;
                byte_count <= 2'b00;
                shift_reg <= {16'b0, in};  // Initialize with first byte
            end
        end
    end

endmodule