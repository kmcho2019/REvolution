module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // 2-bit state variable for 3 states
reg [1:0] next_state;

localparam IDLE = 2'b00;
localparam GOT_1 = 2'b01;
localparam GOT_10 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin // asynchronous reset
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state <= GOT_1;
            end else begin
                next_state <= IDLE;
            end
        end
        GOT_1: begin
            if (~x) begin
                next_state <= GOT_10;
            end else begin
                next_state <= GOT_1;
            end
        end
        GOT_10: begin
            if (x) begin
                next_state <= GOT_1; // after recognizing "101", stay in GOT_1 for overlapping sequences
            end else begin
                next_state <= IDLE;
            end
        end
        default: next_state <= IDLE;
    endcase
end

always @(*) begin
    case (state)
        IDLE: z <= 1'b0;
        GOT_1: z <= 1'b0;
        GOT_10: z <= x;
        default: z <= 1'b0;
    endcase
end

endmodule