module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

logic [7:0] shift_reg;
logic [2:0] bit_count;
logic start_detected;
logic data_valid;

always_ff @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
        bit_count <= 3'b0;
        start_detected <= 1'b0;
        data_valid <= 1'b0;
        out_byte <= 8'b0;
        done <= 1'b0;
    end else begin
        if (in == 1'b0 && ~start_detected) begin
            start_detected <= 1'b1;
            bit_count <= 3'b1;
        end

        if (start_detected) begin
            shift_reg <= {shift_reg[6:0], in};
            bit_count <= bit_count + 1;
        end

        if (bit_count == 8) begin
            if (in == 1'b1) begin
                data_valid <= 1'b1;
            end else begin
                start_detected <= 1'b0;
                bit_count <= 3'b0;
                shift_reg <= 8'b0;
            end
        end

        if (data_valid) begin
            out_byte <= shift_reg;
            done <= 1'b1;
            start_detected <= 1'b0;
            bit_count <= 3'b0;
            shift_reg <= 8'b0;
            data_valid <= 1'b0;
        end

        if (~start_detected) begin
            done <= 1'b0;
        end
    end
end

endmodule