module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding (binary)
    localparam IDLE = 2'b00;
    localparam HIGH = 2'b01;
    localparam LOW  = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = data_in ? HIGH : IDLE;
            HIGH:    next_state = data_in ? HIGH : LOW;
            LOW:     next_state = data_in ? HIGH : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: data_out asserted one cycle when pulse ends (HIGH->LOW transition)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            data_out <= 1'b0;
        else
            // data_out = 1 when currently in HIGH state but input fell to 0, 
            // meaning the next state will be LOW (pulse end)
            data_out <= (state == HIGH) && (data_in == 1'b0);
    end

endmodule