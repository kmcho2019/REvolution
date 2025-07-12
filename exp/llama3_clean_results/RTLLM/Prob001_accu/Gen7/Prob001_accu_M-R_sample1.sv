module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [1:0] state;
reg [1:0] cnt_reg;
reg [9:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'd0; // Idle state
        cnt_reg <= 2'd0;
        sum_reg <= 10'd0;
    end else begin
        case (state)
            2'd0: begin // Idle
                if (valid_in) begin
                    sum_reg <= data_in;
                    cnt_reg <= 2'd1;
                    state <= 2'd1; // Accumulating
                end
            end
            2'd1: begin // Accumulating
                if (valid_in) begin
                    sum_reg <= sum_reg + data_in;
                    cnt_reg <= cnt_reg + 1'd1;
                    if (cnt_reg == 2'd3) begin
                        state <= 2'd2; // Output
                    end
                end
            end
            2'd2: begin // Output
                state <= 2'd0; // Back to idle
            end
        endcase
    end
end

assign valid_out = (state == 2'd2) ? 1'b1 : 1'b0;
assign data_out = (state == 2'd2) ? sum_reg : 10'd0;

endmodule