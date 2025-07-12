module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // One-hot state encoding for three states:
    // IDLE = 3'b001, HIGH = 3'b010, LOW = 3'b100
    localparam IDLE = 3'b001;
    localparam HIGH = 3'b010;
    localparam LOW  = 3'b100;

    reg [2:0] state, next_state;

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

    // Registered output logic to reduce glitches:
    // data_out is asserted one cycle when transitioning from HIGH to LOW (i.e., end of pulse)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            data_out <= 1'b0;
        else
            data_out <= (state == HIGH) && (data_in == 1'b0);
    end

endmodule