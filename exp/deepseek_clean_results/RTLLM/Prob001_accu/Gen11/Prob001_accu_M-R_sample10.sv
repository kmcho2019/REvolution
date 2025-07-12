module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // 2-bit counter (0-3)
    reg [9:0] accumulator;  // 10-bit accumulator
    wire [9:0] next_accum;
    wire [1:0] next_count;
    wire final_cycle;

    // Combinational logic
    assign next_accum = (valid_in && !final_cycle) ? accumulator + data_in : 10'b0;
    assign next_count = (!rst_n) ? 2'b0 : 
                       (valid_in) ? (final_cycle ? 2'b0 : count + 1'b1) : count;
    assign final_cycle = (count == 2'b11) && valid_in;

    // Sequential logic for accumulator
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'b0;
        end
        else begin
            accumulator <= next_accum;
        end
    end

    // Sequential logic for counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
        end
        else begin
            count <= next_count;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            data_out <= final_cycle ? (accumulator + data_in) : data_out;
            valid_out <= final_cycle;
        end
    end

endmodule