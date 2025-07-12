module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [3:0] count;        // One-hot counter (0001, 0010, 0100, 1000)
    reg [9:0] accumulator;  // Running sum
    reg [9:0] sum_pipe;     // Pipelined adder result
    
    // Clock gating signals
    wire clk_en = valid_in || !rst_n;
    wire gated_clk = clk & clk_en;

    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Synchronous reset with clock gating
            count <= 4'b0001;
            accumulator <= 10'b0;
            sum_pipe <= 10'b0;
        end
        else if (valid_in) begin
            // Pipeline stage 1: Compute sum
            sum_pipe <= accumulator + data_in;
            
            // Update one-hot counter
            count <= {count[2:0], count[3]};
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
        else begin
            // Pipeline stage 2: Output and update
            valid_out <= count[3] & valid_in;
            
            if (count[3] & valid_in) begin
                // On 4th input, output sum and reset
                data_out <= sum_pipe;
                accumulator <= 10'b0;
            end
            else if (valid_in) begin
                // Accumulate input
                accumulator <= sum_pipe;
            end
        end
    end

endmodule