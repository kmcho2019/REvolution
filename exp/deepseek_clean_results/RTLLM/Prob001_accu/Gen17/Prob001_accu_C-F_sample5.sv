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
    
    // Continuous assignments for combinational logic
    wire [9:0] next_accum = accumulator + data_in;
    wire count_full = (count == 2'b11);
    
    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            // Update counter
            count <= count_full ? 2'b0 : count + 1'b1;
            
            // Update accumulator
            accumulator <= count_full ? 10'b0 : next_accum;
            
            // Update output and valid when 4 inputs received
            if (count_full) begin
                data_out <= next_accum;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule