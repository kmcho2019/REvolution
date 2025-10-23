module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam IDLE = 2'd0;
    localparam HIGH = 2'd1;
    localparam END  = 2'd2;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: 
                next_state = data_in ? HIGH : IDLE;
            HIGH: 
                next_state = (~data_in) ? END : HIGH;
            END: 
                next_state = IDLE;
            default: 
                next_state = IDLE;
        endcase
    end

    // State update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic: asserted only in END state
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out <= 1'b0;
        else
            data_out <= (state == END) ? 1'b1 : 1'b0;
    end

endmodule