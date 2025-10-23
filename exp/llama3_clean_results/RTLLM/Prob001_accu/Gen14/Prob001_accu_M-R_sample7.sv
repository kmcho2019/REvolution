module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state;
reg [9:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        sum <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (valid_in) begin
                    sum <= data_in;
                    state <= 1;
                end else begin
                    sum <= 0;
                    state <= 0;
                end
            end
            1: begin // ACCUM_1
                if (valid_in) begin
                    sum <= sum + data_in;
                    state <= 2;
                end else begin
                    sum <= 0;
                    state <= 0;
                end
            end
            2: begin // ACCUM_2
                if (valid_in) begin
                    sum <= sum + data_in;
                    state <= 3;
                end else begin
                    sum <= 0;
                    state <= 0;
                end
            end
            3: begin // ACCUM_3
                if (valid_in) begin
                    sum <= sum + data_in;
                    state <= 4;
                end else begin
                    sum <= 0;
                    state <= 0;
                end
            end
            4: begin // OUTPUT
                valid_out <= 1;
                data_out <= sum;
                state <= 0;
            end
        endcase
    end
end

assign valid_out = (state == 4);
assign data_out = sum;

endmodule