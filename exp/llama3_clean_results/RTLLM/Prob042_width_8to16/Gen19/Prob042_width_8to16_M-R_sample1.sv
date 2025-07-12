module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [1:0] state;
reg [7:0] data_lock;
reg [7:0] data_in_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'd0;
        data_lock <= 8'd0;
        data_in_reg <= 8'd0;
    end
    else begin
        case (state)
            2'd0: begin // Idle State
                if (valid_in) begin
                    data_lock <= data_in;
                    state <= 2'd1;
                end
            end
            2'd1: begin // Data Lock State
                if (valid_in) begin
                    data_in_reg <= data_in;
                    state <= 2'd2;
                end
            end
            2'd2: begin // Output State
                state <= 2'd0;
            end
            default: state <= 2'd0;
        endcase
    end
end

assign valid_out = (state == 2'd2);
assign data_out = {data_lock, data_in_reg};

endmodule