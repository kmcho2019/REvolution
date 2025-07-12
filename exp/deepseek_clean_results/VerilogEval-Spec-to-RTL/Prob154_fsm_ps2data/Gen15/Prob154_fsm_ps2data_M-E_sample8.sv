module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg [23:0] shift_reg;
    wire boundary_detected = in[3] & (byte_counter == 2'b00);

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 24'b0;
            byte_counter <= 2'b0;
            done <= 1'b0;
            out_bytes <= 24'bx;
        end else begin
            done <= 1'b0;
            
            if (boundary_detected || byte_counter != 2'b00) begin
                shift_reg <= {shift_reg[15:0], in};
                
                if (byte_counter == 2'b10) begin
                    out_bytes <= {shift_reg[15:0], in};
                    done <= 1'b1;
                    byte_counter <= 2'b00;
                end else begin
                    byte_counter <= byte_counter + 1'b1;
                end
            end
        end
    end

endmodule