module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [23:0] shift_reg;
    reg [1:0] byte_count;
    reg collecting;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            byte_count <= 2'b0;
            collecting <= 1'b0;
            done <= 1'b0;
            out_bytes <= 24'b0;
        end else begin
            done <= 1'b0;
            
            if (!collecting && in[3]) begin
                // Start new message collection
                shift_reg <= {shift_reg[15:0], in};
                byte_count <= 2'b01;
                collecting <= 1'b1;
            end else if (collecting) begin
                // Continue collecting bytes
                shift_reg <= {shift_reg[15:0], in};
                
                if (byte_count == 2'b10) begin
                    // Third byte received
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    collecting <= 1'b0;
                    byte_count <= 2'b00;
                end else begin
                    byte_count <= byte_count + 1;
                end
            end
        end
    end

endmodule