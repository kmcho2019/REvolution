module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    // Define states
    parameter IDLE = 2'b00;
    parameter GOT_1 = 2'b01;
    parameter GOT_10 = 2'b10;

    reg [1:0] current_state;
    reg [1:0] next_state;

    // Asynchronous reset
    always @(negedge aresetn or posedge clk) begin
        if (~aresetn) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (x) begin
                    next_state = GOT_1;
                end else begin
                    next_state = IDLE;
                end
            end
            GOT_1: begin
                if (~x) begin
                    next_state = GOT_10;
                end else begin
                    next_state = GOT_1;
                end
            end
            GOT_10: begin
                if (x) begin
                    next_state = IDLE; // We have seen the sequence "101"
                end else begin
                    next_state = GOT_1; // Not the sequence, go back to got_1
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    assign z = (current_state == GOT_10) && x;

endmodule