module TopModule (
    input  wire [2:0] y,  // current state bits y[2], y[1], y[0]
    input  wire       w,  // input
    output wire       Y1   // output equals current y[1]
);

    // Function to compute next state bit y[1] based on current y and w
    function automatic next_y1_fn(input [2:0] state, input w_in);
        begin
            case (state)
                3'b000: next_y1_fn = 1'b0;              // A: w=0->B(001)y1=0, w=1->A(000)y1=0
                3'b001: next_y1_fn = 1'b1;              // B: w=0->C(010)y1=1, w=1->D(011)y1=1
                3'b010: next_y1_fn = w_in ? 1'b1 : 1'b0;// C: w=0->E(100)y1=0, w=1->D(011)y1=1
                3'b011: next_y1_fn = 1'b0;              // D: w=0->F(101)y1=0, w=1->A(000)y1=0
                3'b100: next_y1_fn = w_in ? 1'b1 : 1'b0;// E: w=0->E(100)y1=0, w=1->D(011)y1=1
                3'b101: next_y1_fn = 1'b1;              // F: w=0->C(010)y1=1, w=1->D(011)y1=1
                default: next_y1_fn = 1'b0;
            endcase
        end
    endfunction

    wire next_y1 = next_y1_fn(y, w);

    assign Y1 = y[1];

endmodule