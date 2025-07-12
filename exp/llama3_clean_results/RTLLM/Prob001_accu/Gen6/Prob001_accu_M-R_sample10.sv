module accu (
    input         clk, 
    input         rst_n, 
    input  [7:0]   data_in, 
    input         valid_in, 
    output        valid_out, 
    output [9:0]  data_out
);

reg [1:0] state;
reg [1:0] counter;
reg [9:0] sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'd0;
        counter <= 2'd0;
        sum_reg <= 10'd0;
    end else begin
        case (state)
            2'd0: begin // Idle state
                if (valid_in) begin
                    state <= 2'd1;
                    sum_reg <= data_in;
                    counter <= 2'd1;
                end
            end
            2'd1: begin // Accumulation state
                if (valid_in) begin
                    if (counter == 2'd3) begin
                        sum_reg <= sum_reg + data_in;
                        counter <= 2'd0;
                        state <= 2'd2;
                    end else begin
                        sum_reg <= sum_reg + data_in;
                        counter <= counter + 1'd1;
                    end
                end else begin
                    state <= 2'd0;
                end
            end
            2'd2: begin // Output state
                state <= 2'd0;
            end
            default: begin
                state <= 2'd0;
            end
        endcase
    end
end

assign valid_out = (state == 2'd2);
assign data_out = (state == 2'd2)? sum_reg : 10'd0;

endmodule