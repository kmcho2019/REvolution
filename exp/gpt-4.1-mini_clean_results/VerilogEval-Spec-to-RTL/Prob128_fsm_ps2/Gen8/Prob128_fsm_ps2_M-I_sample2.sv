module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    // State encoding as localparams (2 bits)
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE:  next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and done pulse generation
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
        end else begin
            state <= next_state;
            // Assert done only on transition from BYTE2 state, else hold done low without toggling
            done <= (state == BYTE2);
        end
    end

endmodule