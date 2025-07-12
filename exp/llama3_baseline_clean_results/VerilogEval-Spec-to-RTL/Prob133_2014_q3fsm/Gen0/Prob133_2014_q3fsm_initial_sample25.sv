module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// State definition
reg [1:0] state;
parameter A = 2'b00, B = 2'b01, B_COUNTER = 2'b10, B_OUTPUT = 2'b11;

// Counter for clock cycles
reg [1:0] counter;

// Counter for w = 1 in three clock cycles
reg [1:0] w_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
        counter <= 2'b00;
        w_counter <= 2'b00;
        z <= 1'b0;
    end else begin
        case (state)
            A: begin
                if (s == 1'b1) begin
                    state <= B_COUNTER;
                    counter <= 2'b01;
                    w_counter <= 2'b00;
                end
            end
            B_COUNTER: begin
                if (counter == 2'b11) begin
                    state <= B_OUTPUT;
                    z <= (w_counter == 2'b10) ? 1'b1 : 1'b0;
                end else begin
                    counter <= counter + 1;
                    if (w == 1'b1) begin
                        w_counter <= w_counter + 1;
                    end
                end
            end
            B_OUTPUT: begin
                state <= B_COUNTER;
                counter <= 2'b01;
                w_counter <= 2'b00;
            end
        endcase
    end
end

endmodule