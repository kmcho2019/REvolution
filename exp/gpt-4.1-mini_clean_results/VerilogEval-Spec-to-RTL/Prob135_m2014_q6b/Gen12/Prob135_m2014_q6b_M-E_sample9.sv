module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Define states by their encoding
    wire state_A = (y == 3'b000);
    wire state_B = (y == 3'b001);
    wire state_C = (y == 3'b010);
    wire state_D = (y == 3'b011);
    wire state_E = (y == 3'b100);
    wire state_F = (y == 3'b101);

    // Compute next y[1] based on state and input w
    // Extract next_y1 according to FSM transitions:
    // Use direct mapping from the state and input to next y1 bit

    reg next_y1;
    always @(*) begin
        if (state_A) begin
            // A: y=000; transitions: 0->B(001), 1->A(000)
            // next y[1] for B=0, A=0 -> 0
            next_y1 = 1'b0;
        end else if (state_B) begin
            // B: 0->C(010), 1->D(011)
            // next y[1] for C=1, D=1 -> 1
            next_y1 = 1'b1;
        end else if (state_C) begin
            // C: 0->E(100), 1->D(011)
            // y1(E)=0, y1(D)=1; depends on w
            next_y1 = (w) ? 1'b1 : 1'b0;
        end else if (state_D) begin
            // D: 0->F(101), 1->A(000)
            // y1(F)=0, y1(A)=0
            next_y1 = 1'b0;
        end else if (state_E) begin
            // E: 0->E(100), 1->D(011)
            // y1(E)=0, y1(D)=1; input is y[1] from problem but here input is w
            // The problem states "E (1) --0--> E", "E (1) --1--> D"
            // So w represents input in this case. For E: if w=1 next y1=1 else 0
            next_y1 = (w) ? 1'b1 : 1'b0;
        end else if (state_F) begin
            // F: 0->C(010), 1->D(011)
            // y1(C)=1, y1(D)=1
            next_y1 = 1'b1;
        end else begin
            next_y1 = 1'b0;
        end
    end

    // Output Y1 is current y[1]
    assign Y1 = y[1];

endmodule