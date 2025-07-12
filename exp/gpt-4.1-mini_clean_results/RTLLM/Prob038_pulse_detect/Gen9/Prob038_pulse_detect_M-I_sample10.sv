module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire data_out
);

    // One-hot state encoding
    localparam IDLE = 3'b001;
    localparam HIGH = 3'b010;
    localparam LOW  = 3'b100;

    reg [2:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
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

    // State register update (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Mealy output: data_out is high when state is HIGH and data_in falls to 0 (i.e. next_state is LOW)
    // This can be derived as current state is HIGH and next state is LOW, so output = (state == HIGH && next_state == LOW)
    assign data_out = (state == HIGH) && (next_state == LOW);

endmodule