module TopModule(
    input        clk,
    input        reset,
    input        w,
    output       z
);

    reg [2:0] current_state; // States: A (3'b000), B (3'b001), C (3'b010), D (3'b011), E (3'b100), F (3'b101)
    reg [2:0] next_state;

    localparam STATE_A = 3'b000;
    localparam STATE_B = 3'b001;
    localparam STATE_C = 3'b010;
    localparam STATE_D = 3'b011;
    localparam STATE_E = 3'b100;
    localparam STATE_F = 3'b101;

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (~w) begin
                    next_state = STATE_B;
                end else begin
                    next_state = STATE_A;
                end
            end
            STATE_B: begin
                if (~w) begin
                    next_state = STATE_C;
                end else begin
                    next_state = STATE_D;
                end
            end
            STATE_C: begin
                if (~w) begin
                    next_state = STATE_E;
                end else begin
                    next_state = STATE_D;
                end
            end
            STATE_D: begin
                if (~w) begin
                    next_state = STATE_F;
                end else begin
                    next_state = STATE_A;
                end
            end
            STATE_E: begin
                if (w) begin
                    next_state = STATE_E;
                end else begin
                    next_state = STATE_D;
                end
            end
            STATE_F: begin
                if (w) begin
                    next_state = STATE_D;
                end else begin
                    next_state = STATE_C;
                end
            end
            default: next_state = STATE_A;
        endcase
    end

    // Output logic
    assign z = (current_state == STATE_E) || (current_state == STATE_F);

endmodule