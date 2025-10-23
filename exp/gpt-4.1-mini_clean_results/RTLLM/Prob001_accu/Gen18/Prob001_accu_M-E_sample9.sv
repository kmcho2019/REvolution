module accu (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        valid_in,
    output reg         valid_out,
    output reg  [9:0]  data_out
);

    reg [7:0] data_reg0, data_reg1, data_reg2, data_reg3;
    reg [1:0] count;

    // Combinational wires for parallel addition
    wire [9:0] sum01 = data_reg0 + data_reg1;
    wire [9:0] sum23 = data_reg2 + data_reg3;
    wire [9:0] final_sum = sum01 + sum23;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg0 <= 8'd0;
            data_reg1 <= 8'd0;
            data_reg2 <= 8'd0;
            data_reg3 <= 8'd0;
            count     <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0; // default low

            if (valid_in) begin
                case (count)
                    2'd0: data_reg0 <= data_in;
                    2'd1: data_reg1 <= data_in;
                    2'd2: data_reg2 <= data_in;
                    2'd3: data_reg3 <= data_in;
                endcase

                if (count == 2'd3) begin
                    // When 4th data_in arrives, output sum and pulse valid_out
                    data_out  <= final_sum;
                    valid_out <= 1'b1;
                    count     <= 2'd0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule