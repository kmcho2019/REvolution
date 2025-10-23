module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] counter;
    reg [9:0] accumulator;
    wire counter_full = (counter == 2'b11) & valid_in;

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'b00;
        end
        else if (valid_in) begin
            counter <= counter + 1'b1;
        end
    end

    // Accumulator logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            accumulator <= 10'b0;
        end
        else if (valid_in) begin
            if (counter_full) begin
                accumulator <= 10'b0;
            end
            else begin
                accumulator <= accumulator + data_in;
            end
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= counter_full;
            if (counter_full) begin
                data_out <= accumulator + data_in;
            end
        end
    end

endmodule