module accu (
    input            clk,
    input            rst_n,
    input      [7:0] data_in,
    input            valid_in,
    output reg       valid_out,
    output reg [9:0] data_out
);

    reg [7:0] data_reg [0:3];  // 4-entry shift register array
    reg [1:0] count;           // Counts number of valid inputs stored

    integer i;
    reg [10:0] sum_comb;       // Wider sum for combinational addition to avoid overflow

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count     <= 2'd0;
            valid_out <= 1'b0;
            data_out  <= 10'd0;
            for (i = 0; i < 4; i = i + 1) begin
                data_reg[i] <= 8'd0;
            end
        end else begin
            valid_out <= 1'b0; // default low each cycle

            if (valid_in) begin
                // Shift data_in into data_reg array
                // Shift older data down the array
                data_reg[3] <= data_reg[2];
                data_reg[2] <= data_reg[1];
                data_reg[1] <= data_reg[0];
                data_reg[0] <= data_in;

                if (count == 2'd3) begin
                    // Output sum of 4 data elements
                    valid_out <= 1'b1;
                    // data_out computed combinationally below
                    count <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

    // Combinational sum of the 4 data_reg elements
    always @(*) begin
        if (count == 2'd3 && valid_in) begin
            // sum all four elements
            sum_comb = data_in + data_reg[0] + data_reg[1] + data_reg[2];
        end else begin
            sum_comb = 11'd0;
        end
    end

    // Register output data_out at clock edge when valid_out is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'd0;
        end else begin
            if (valid_out) begin
                data_out <= sum_comb[9:0];
            end
        end
    end

endmodule