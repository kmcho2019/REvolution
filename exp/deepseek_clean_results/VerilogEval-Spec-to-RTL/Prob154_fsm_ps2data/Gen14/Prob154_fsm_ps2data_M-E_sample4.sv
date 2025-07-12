module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [1:0] byte_count;  // Counts 0-2 for 3 bytes
    reg collecting;        // 1 when collecting message bytes
    reg [23:0] shift_reg;  // Shift register for byte collection

    // Combinatorial done signal
    assign done = (byte_count == 2'd2) && collecting;

    always @(posedge clk) begin
        if (reset) begin
            collecting <= 1'b0;
            byte_count <= 2'd0;
            shift_reg <= 24'bx;
            out_bytes <= 24'bx;
        end else begin
            if (!collecting) begin
                // IDLE state - wait for start byte
                if (in[3]) begin
                    collecting <= 1'b1;
                    byte_count <= 2'd0;
                    shift_reg <= {16'b0, in};
                end
            end else begin
                // COLLECT state - shift in new byte
                shift_reg <= {shift_reg[15:0], in};
                byte_count <= byte_count + 1;

                // Handle message completion
                if (byte_count == 2'd2) begin
                    out_bytes <= {shift_reg[15:0], in};
                    collecting <= 1'b0;
                end
            end
        end
    end

endmodule