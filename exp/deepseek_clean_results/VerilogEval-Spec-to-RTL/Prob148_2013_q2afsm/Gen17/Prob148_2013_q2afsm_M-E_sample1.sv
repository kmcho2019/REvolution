module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding that directly represents output grants
    // Format: {grant2, grant1, grant0}
    parameter [2:0] STATE_IDLE  = 3'b000;  // A
    parameter [2:0] STATE_G0    = 3'b001;  // B
    parameter [2:0] STATE_G1    = 3'b010;  // C
    parameter [2:0] STATE_G2    = 3'b100;  // D

    reg [2:0] state;

    // Output is directly the state (except for idle state)
    assign g = (state == STATE_IDLE) ? 3'b000 : state;

    // State transitions
    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_IDLE;
        end else begin
            case (state)
                STATE_IDLE: begin
                    // Priority encoder with device 0 highest
                    if (r[0])       state <= STATE_G0;
                    else if (r[1])   state <= STATE_G1;
                    else if (r[2])   state <= STATE_G2;
                    else            state <= STATE_IDLE;
                end
                STATE_G0: state <= r[0] ? STATE_G0 : STATE_IDLE;
                STATE_G1: state <= r[1] ? STATE_G1 : STATE_IDLE;
                STATE_G2: state <= r[2] ? STATE_G2 : STATE_IDLE;
                default:   state <= STATE_IDLE;
            endcase
        end
    end

endmodule