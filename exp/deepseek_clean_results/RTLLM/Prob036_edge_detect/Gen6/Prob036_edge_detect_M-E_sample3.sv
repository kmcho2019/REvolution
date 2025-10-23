module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    // State encoding
    localparam S00 = 2'b00;  // Previous: 0, Current: 0
    localparam S01 = 2'b01;  // Previous: 0, Current: 1 (rising edge)
    localparam S10 = 2'b10;  // Previous: 1, Current: 0 (falling edge)
    localparam S11 = 2'b11;  // Previous: 1, Current: 1

    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            S00: next_state = a ? S01 : S00;
            S01: next_state = a ? S11 : S10;
            S10: next_state = a ? S01 : S00;
            S11: next_state = a ? S11 : S10;
            default: next_state = S00;
        endcase
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S00;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (registered)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= (state == S00 && next_state == S01);
            down <= (state == S11 && next_state == S10);
        end
    end

endmodule