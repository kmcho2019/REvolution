module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // Binary encoding for states
    localparam IDLE = 2'b00;
    localparam HIGH = 2'b01;
    localparam LOW  = 2'b10;

    reg [1:0] state, next_state;

    // Sequential logic: state and output registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            data_out <= 1'b0;
        end else begin
            data_out <= (state == HIGH) && (next_state == LOW);
            state <= next_state;
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = HIGH;
                else
                    next_state = IDLE;
            end
            HIGH: begin
                if (!data_in)
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

endmodule