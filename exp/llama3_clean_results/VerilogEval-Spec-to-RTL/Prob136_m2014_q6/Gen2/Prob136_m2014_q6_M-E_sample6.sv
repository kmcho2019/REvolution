module TopModule(
    input clk,
    input reset,
    input w,
    output logic z
);

enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

logic [2:0] next_state_lut [6][2];
logic z_lut [6];

initial begin
    next_state_lut[A][0] = B;
    next_state_lut[A][1] = A;
    next_state_lut[B][0] = C;
    next_state_lut[B][1] = D;
    next_state_lut[C][0] = E;
    next_state_lut[C][1] = D;
    next_state_lut[D][0] = F;
    next_state_lut[D][1] = A;
    next_state_lut[E][0] = E;
    next_state_lut[E][1] = D;
    next_state_lut[F][0] = C;
    next_state_lut[F][1] = D;

    z_lut[A] = 0;
    z_lut[B] = 0;
    z_lut[C] = 0;
    z_lut[D] = 0;
    z_lut[E] = 1;
    z_lut[F] = 1;
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state_lut[state][w];
    end
end

always_comb begin
    next_state = next_state_lut[state][w];
    z = z_lut[state];
end

endmodule