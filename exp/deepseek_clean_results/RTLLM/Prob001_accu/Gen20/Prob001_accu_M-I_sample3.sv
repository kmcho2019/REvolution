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
    reg [7:0] data_pipe[0:1];
    reg valid_pipe;

    // Clock gating logic
    wire accum_clk_en = valid_in | (count != 0);
    wire accum_clk;
    assign accum_clk = clk & accum_clk_en;

    // First stage: Partial sum pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_pipe[0] <= 8'b0;
            data_pipe[1] <= 8'b0;
            valid_pipe <= 1'b0;
        end else if (valid_in) begin
            data_pipe[0] <= data_in;
            data_pipe[1] <= data_pipe[0];
            valid_pipe <= (count == 2'd2);
        end
    end

    // Second stage: Final accumulation with carry-save
    always @(posedge accum_clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            if (valid_in) begin
                if (count == 2'd3) begin
                    // Final accumulation
                    accumulator <= {2'b0, data_in} + {2'b0, data_pipe[0]} + 
                                  {2'b0, data_pipe[1]};
                    data_out <= accumulator + {2'b0, data_in} + 
                               {2'b0, data_pipe[0]} + {2'b0, data_pipe[1]};
                    valid_out <= 1'b1;
                    count <= 2'b0;
                end else begin
                    // Intermediate accumulation
                    accumulator <= accumulator + {2'b0, data_in};
                    count <= count + 1'b1;
                    valid_out <= 1'b0;
                end
            end else begin
                valid_out <= 1'b0;
            end
        end
    end

endmodule