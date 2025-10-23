module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [2:0] state; // 3-bit state register

// state definition
localparam IDLE = 3'b000;
localparam GOT_1 = 3'b001;
localparam GOT_11 = 3'b010;
localparam GOT_110 = 3'b011;

always @(posedge clk) begin
    if (reset) begin // reset is active high
        state <= IDLE; // reset state to IDLE
        start_shifting <= 0; // reset start_shifting to 0
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    state <= GOT_1; // if data is '1', move to GOT_1 state
                end
            end
            GOT_1: begin
                if (data) begin
                    state <= GOT_11; // if data is '1', move to GOT_11 state
                end else begin
                    state <= IDLE; // if data is '0', move back to IDLE state
                end
            end
            GOT_11: begin
                if (~data) begin // ~data is '0'
                    state <= GOT_110; // if data is '0', move to GOT_110 state
                end else begin
                    state <= GOT_1; // if data is '1', move back to GOT_1 state
                end
            end
            GOT_110: begin
                if (data) begin
                    start_shifting <= 1; // if data is '1', set start_shifting to 1
                end else begin
                    state <= IDLE; // if data is '0', move back to IDLE state
                end
            end
        endcase
    end
end

endmodule