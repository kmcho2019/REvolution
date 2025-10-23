module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state; // idle and running states
reg [31:0] sum; // running sum of input bits

parameter IDLE = 2'b00;
parameter RUNNING = 2'b01;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= IDLE;
        sum <= 32'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~x) begin
                    state <= RUNNING;
                    sum <= 1'b1; // start with 1 for 2's complement
                end
            end
            RUNNING: begin
                if (x) begin
                    sum <= {sum[30:0], 1'b0}; // shift left
                end else begin
                    sum <= {sum[30:0], 1'b1}; // shift left and set LSB
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: z <= 1'b0;
        RUNNING: z <= ~sum[31]; // output is the MSB of the sum
    endcase
end

endmodule