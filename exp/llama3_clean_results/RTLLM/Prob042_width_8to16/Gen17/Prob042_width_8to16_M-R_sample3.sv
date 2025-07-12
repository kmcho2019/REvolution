module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg [1:0] state; // 0: idle, 1: locked, 2: output
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        data_lock <= 8'b0;
        data_out_reg <= 16'b0;
    end else begin
        case (state)
            0: begin // idle
                if (valid_in) begin
                    state <= 1;
                    data_lock <= data_in;
                end
            end
            1: begin // locked
                if (valid_in) begin
                    state <= 2;
                    data_out_reg <= {data_lock, data_in};
                end
            end
            2: begin // output
                state <= 0;
            end
        endcase
    end
end

assign valid_out = (state == 2);
assign data_out = data_out_reg;

endmodule