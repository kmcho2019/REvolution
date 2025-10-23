module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // 2 states: A (0) and B (1)
reg [1:0] counter; // counter for 3 clock cycles
reg [1:0] w_count; // count of w=1 occurrences

// define states
parameter A = 2'b00;
parameter B = 2'b01;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
        counter <= 0;
        w_count <= 0;
        z <= 0;
    end else begin
        case (state)
            A: begin
                if (s) begin
                    state <= B;
                    counter <= 1;
                    w_count <= 0;
                end
            end
            B: begin
                if (counter < 3) begin
                    counter <= counter + 1;
                    if (w) begin
                        w_count <= w_count + 1;
                    end
                end else begin
                    counter <= 1;
                    if (w_count == 2) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    w_count <= 0;
                    if (w) begin
                        w_count <= 1;
                    end
                end
            end
        endcase
    end
end

endmodule