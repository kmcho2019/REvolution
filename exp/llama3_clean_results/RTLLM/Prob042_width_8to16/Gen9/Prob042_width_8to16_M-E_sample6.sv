module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] fifo [1:0];
reg [1:0] fifo_ptr;
reg [1:0] state;
reg valid_out_reg;
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        fifo_ptr <= 0;
        state <= 0;
        valid_out_reg <= 0;
        data_out_reg <= 0;
    end else begin
        case (state)
            0: begin
                if (valid_in) begin
                    fifo[0] <= data_in;
                    fifo_ptr <= 1;
                    state <= 1;
                end
            end
            1: begin
                if (valid_in) begin
                    fifo[1] <= data_in;
                    state <= 2;
                end
            end
            2: begin
                data_out_reg <= {fifo[1], fifo[0]};
                valid_out_reg <= 1;
                state <= 0;
            end
            default: state <= 0;
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule