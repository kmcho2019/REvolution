module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [1:0] current_state; // State variable
reg [1:0] count; // Counter for clock cycles
reg w_count; // Counter for w = 1
reg prev_state; // Previous state

parameter A = 2'b00; // State A
parameter B = 2'b01; // State B

always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
        count <= 2'b00;
        w_count <= 1'b0;
    end else begin
        case (current_state)
            A: begin
                if (s) begin
                    current_state <= B;
                    count <= 2'b01;
                    w_count <= w;
                end else begin
                    current_state <= A;
                end
            end
            B: begin
                if (count == 2'b11) begin // Three clock cycles have passed
                    z <= (w_count == 2'b10) ? 1'b1 : 1'b0;
                    w_count <= w;
                    count <= 2'b01;
                end else begin
                    count <= count + 1;
                    w_count <= w_count + w;
                end
            end
        endcase
    end
end

assign z = (current_state == B && count == 2'b00) ? (w_count == 2'b10) ? 1'b1 : 1'b0 : 1'b0;

endmodule