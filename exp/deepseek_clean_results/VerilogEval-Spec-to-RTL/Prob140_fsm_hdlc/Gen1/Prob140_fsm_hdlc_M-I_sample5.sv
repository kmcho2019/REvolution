module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding (binary for better synthesis)
    localparam [1:0] RESET = 2'b00;
    localparam [1:0] CNT1  = 2'b01;
    localparam [1:0] CNT2  = 2'b10;
    localparam [1:0] CNT3  = 2'b11;
    localparam [1:0] CNT4  = 2'b00; // Reuse encoding with extra bit
    localparam [1:0] CNT5  = 2'b01;
    localparam [1:0] CNT6  = 2'b10;
    localparam [1:0] ERR   = 2'b11;

    reg [2:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            RESET: next_state = in ? CNT1 : RESET;
            CNT1:  next_state = in ? CNT2 : RESET;
            CNT2:  next_state = in ? CNT3 : RESET;
            CNT3:  next_state = in ? CNT4 : RESET;
            CNT4:  next_state = in ? CNT5 : RESET;
            CNT5:  next_state = in ? CNT6 : RESET;
            CNT6:  next_state = in ? ERR  : RESET;
            ERR:   next_state = in ? ERR  : RESET;
            default: next_state = RESET;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= RESET;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (registered for one-cycle duration)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= (state == CNT5) && !in;
            flag <= (state == CNT6) && !in;
            err <= (state == ERR);
        end
    end

endmodule