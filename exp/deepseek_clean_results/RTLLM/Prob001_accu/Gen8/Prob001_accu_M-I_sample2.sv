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
    reg gated_clk;

    // Clock gating logic
    always @(*) begin
        gated_clk = clk & (valid_in | (count != 0));
    end

    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Pipeline stage 1: accumulate first two inputs
            if (count < 2'b10) begin
                accumulator <= accumulator + data_in;
                count <= count + 1'b1;
                valid_out <= 1'b0;
            end
            // Pipeline stage 2: accumulate last two inputs and output
            else begin
                data_out <= accumulator + data_in;
                valid_out <= 1'b1;
                count <= 2'b00;
                accumulator <= 10'b0;
            end
        end
    end

    // Output register for better timing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
        end
        else if (valid_out) begin
            data_out <= accumulator + data_in;
        end
    end

endmodule