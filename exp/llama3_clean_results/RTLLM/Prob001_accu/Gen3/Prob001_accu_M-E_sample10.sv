module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] state;
reg [9:0] sum;
reg [1:0] count;

// FSM state transitions
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        count <= 2'b00;
    end else begin
        case (state)
            2'b00: begin
                if (valid_in) begin
                    state <= 2'b01;
                    count <= 2'b01;
                    sum <= data_in;
                end
            end
            2'b01: begin
                if (valid_in) begin
                    if (count == 2'b11) begin
                        state <= 2'b10;
                        count <= 2'b00;
                    end else begin
                        count <= count + 1'b1;
                    end
                    sum <= sum + data_in;
                end
            end
            2'b10: begin
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (state == 2'b10) begin
        valid_out <= 1'b1;
        data_out <= sum;
    end else begin
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
end

endmodule