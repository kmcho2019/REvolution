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
    wire count_full = (count == 2'd3);
    
    // Next count value
    wire [1:0] next_count = valid_in ? (count_full ? 2'd0 : count + 1'b1) : count;
    
    // Next accumulator value
    wire [9:0] next_accum = valid_in ? 
                          (count == 2'd0 ? data_in : accumulator + data_in) : 
                          accumulator;
    
    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'd0;
            accumulator <= 10'd0;
            data_out <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            count <= next_count;
            accumulator <= next_accum;
            
            // Output the accumulated value when we have 4 inputs
            valid_out <= valid_in & count_full;
            if (valid_in & count_full) begin
                data_out <= next_accum;
            end
        end
    end

endmodule