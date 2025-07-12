module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // State encoding using localparams
    localparam IDLE = 2'd0;
    localparam HIGH = 2'd1;
    localparam LOW  = 2'd2;

    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (~data_in)
                    next_state = LOW;
                else
                    next_state = HIGH;
            end
            LOW: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // State update sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output combinational logic (Mealy output)
    // Output '1' only when current state is HIGH and data_in goes low (pulse end)
    assign data_out = (state == HIGH) && (data_in == 1'b0);

endmodule