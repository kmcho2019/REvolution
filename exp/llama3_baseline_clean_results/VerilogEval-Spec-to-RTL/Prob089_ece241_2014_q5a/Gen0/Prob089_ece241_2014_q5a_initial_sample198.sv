module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;
reg [31:0] sum;
reg msb_seen;
reg msb_value;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if (!areset) begin
                nextState = 2'b01;
                sum = 0;
                msb_seen = 0;
                msb_value = 0;
            end else begin
                nextState = 2'b00;
            end
        end
        2'b01: begin // RUNNING
            if (areset) begin
                nextState = 2'b00;
            end else begin
                nextState = 2'b01;
                if (!msb_seen) begin
                    msb_seen = 1;
                    msb_value = x;
                end
                sum = (sum >> 1) | (x << 31);
            end
        end
        default: begin
            nextState = 2'b00;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = 2'b00;
        z = 0;
    end else begin
        state = nextState;
        z = ~sum[0] + 1'b1;
    end
end

endmodule