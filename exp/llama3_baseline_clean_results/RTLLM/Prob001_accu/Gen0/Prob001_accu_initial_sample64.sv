module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [9:0] data_out_reg;
reg       valid_out_reg;
reg [1:0] counter;
reg [9:0] accumulator;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        valid_out_reg <= 1'b0;
        counter <= 2'd0;
        accumulator <= 10'd0;
    end else begin
        valid_out_reg <= 1'b0;
        if (valid_in) begin
            case (counter)
                2'd0: begin
                    accumulator <= {2'd0, data_in};
                    counter <= counter + 1'd1;
                end
                2'd1: begin
                    accumulator <= accumulator + {2'd0, data_in};
                    counter <= counter + 1'd1;
                end
                2'd2: begin
                    accumulator <= accumulator + {2'd0, data_in};
                    counter <= counter + 1'd1;
                end
                2'd3: begin
                    accumulator <= accumulator + {2'd0, data_in};
                    valid_out_reg <= 1'b1;
                    counter <= 2'd0;
                end
                default: ;
            endcase
        end else begin
            counter <= 2'd0;
            accumulator <= 10'd0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

always @(posedge clk) begin
    data_out_reg <= accumulator;
end

endmodule