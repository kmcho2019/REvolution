module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output valid_out,
    output [15:0] data_out
);

reg [7:0] data_lock;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        data_lock <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (valid_in) begin
                    state <= 1;
                    data_lock <= data_in;
                end
            end
            1: begin // WAITING
                if (valid_in) begin
                    state <= 0;
                    // Output will be generated through assign statement
                end
            end
            default: state <= 0;
        endcase
    end
end

assign valid_out = (state == 1 && valid_in);
assign data_out = {data_lock, data_in};

endmodule