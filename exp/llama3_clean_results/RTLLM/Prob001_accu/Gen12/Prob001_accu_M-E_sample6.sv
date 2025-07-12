module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [9:0] sum;
reg [1:0] state;
reg valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 0;
        sum <= 0;
        valid_out_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (valid_in) begin
                    state <= 1;
                    sum <= data_in;
                end else begin
                    state <= 0;
                    sum <= 0;
                end
            end
            1: begin // ACCUM1
                if (valid_in) begin
                    state <= 2;
                    sum <= sum + data_in;
                end else begin
                    state <= 0;
                    sum <= 0;
                end
            end
            2: begin // ACCUM2
                if (valid_in) begin
                    state <= 3;
                    sum <= sum + data_in;
                end else begin
                    state <= 0;
                    sum <= 0;
                end
            end
            3: begin // ACCUM3
                if (valid_in) begin
                    state <= 4;
                    sum <= sum + data_in;
                end else begin
                    state <= 0;
                    sum <= 0;
                end
            end
            4: begin // OUTPUT
                valid_out_reg <= 1;
                state <= 0;
            end
        endcase
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

always @(posedge clk) begin
    valid_out_reg <= 0;
end

endmodule