module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Binary counter (0-3)
    reg [9:0] accumulator;  // Accumulation register
    wire [9:0] next_accum;  // Next accumulator value

    // Combinational next accumulator value
    assign next_accum = accumulator + data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
        end
        else if (valid_in) begin
            if (count == 2'b11) begin
                // On 4th input, store sum and reset
                data_out <= next_accum;
                accumulator <= 10'b0;
                count <= 2'b00;
            end
            else begin
                // Accumulate and increment count
                accumulator <= next_accum;
                count <= count + 1'b1;
            end
        end
    end

    // Combinational valid_out generation
    always @(*) begin
        valid_out = (valid_in && (count == 2'b11));
    end

endmodule