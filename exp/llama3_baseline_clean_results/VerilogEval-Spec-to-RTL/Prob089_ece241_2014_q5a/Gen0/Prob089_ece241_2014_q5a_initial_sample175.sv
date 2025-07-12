module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] number; // Accumulated number, arbitrary length, here we use 32 bits as an example
reg [31:0] complement; // 2's complement of the accumulated number
reg [4:0] bit_count; // Counter for number of bits
reg [31:0] output_number; // Output number
reg output_bit; // Output bit
reg reset_state, accumulate_state, output_state; // Finite state machine states

always @(posedge clk or posedge areset) begin
    if (areset) begin
        reset_state <= 1'b1;
        accumulate_state <= 1'b0;
        output_state <= 1'b0;
        number <= 32'd0;
        complement <= 32'd0;
        output_number <= 32'd0;
        output_bit <= 1'b0;
        bit_count <= 5'd0;
    end else begin
        case ({reset_state, accumulate_state, output_state})
            3'b100: begin // Reset state
                if (~areset) begin
                    reset_state <= 1'b0;
                    accumulate_state <= 1'b1;
                end
            end
            3'b010: begin // Accumulate state
                number <= {number[30:0], x};
                bit_count <= bit_count + 1;
                if (areset) begin
                    reset_state <= 1'b1;
                    accumulate_state <= 1'b0;
                end
            end
            3'b001: begin // Output state
                if (bit_count > 0) begin
                    output_bit <= output_number[31];
                    output_number <= output_number << 1;
                    bit_count <= bit_count - 1;
                    if (bit_count == 0) begin
                        output_state <= 1'b0;
                        accumulate_state <= 1'b1;
                    end
                end
            end
            default: begin
                reset_state <= 1'b1;
                accumulate_state <= 1'b0;
                output_state <= 1'b0;
            end
        endcase
    end
end

always @(*) begin
    if (~areset && accumulate_state && bit_count > 0 && number[31]) begin
        complement = ~number + 1;
        output_number = complement;
        output_state <= 1'b1;
        accumulate_state <= 1'b0;
    end
end

assign z = output_bit;

endmodule