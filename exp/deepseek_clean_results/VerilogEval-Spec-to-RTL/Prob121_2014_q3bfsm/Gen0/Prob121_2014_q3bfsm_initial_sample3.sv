module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    reg [2:0] state;
    reg next_z;

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            3'b000: begin
                if (x) next_state = 3'b001;
                else next_state = 3'b000;
                next_z = 1'b0;
            end
            3'b001: begin
                if (x) next_state = 3'b100;
                else next_state = 3'b001;
                next_z = 1'b0;
            end
            3'b010: begin
                if (x) next_state = 3'b001;
                else next_state = 3'b010;
                next_z = 1'b0;
            end
            3'b011: begin
                if (x) next_state = 3'b010;
                else next_state = 3'b001;
                next_z = 1'b1;
            end
            3'b100: begin
                if (x) next_state = 3'b100;
                else next_state = 3'b011;
                next_z = 1'b1;
            end
            default: begin
                next_state = 3'b000;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state;
    end

    assign z = next_z;

endmodule