module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;
    wire [9:0] next_accum;
    wire [1:0] next_count;
    wire next_valid_out;

    // Combinational logic
    assign next_accum = valid_in ? accumulator + data_in : accumulator;
    assign next_count = (!rst_n) ? 2'b0 : 
                       (valid_in && count == 2'b11) ? 2'b0 : 
                       valid_in ? count + 1'b1 : count;
    assign next_valid_out = valid_in && (count == 2'b11);

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            count <= next_count;
            valid_out <= next_valid_out;
            
            if (valid_in) begin
                accumulator <= next_accum;
                if (count == 2'b11) begin
                    data_out <= next_accum;
                    accumulator <= 10'b0;  // Reset accumulator for next cycle
                end
            end
        end
    end

endmodule