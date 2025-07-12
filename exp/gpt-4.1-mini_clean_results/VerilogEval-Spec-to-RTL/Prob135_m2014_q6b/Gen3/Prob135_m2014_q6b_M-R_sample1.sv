module TopModule (
    input  wire [2:0] y,  // current state bits y[2], y[1], y[0]
    input  wire       w,  // input
    output wire       Y1   // output equals current y[1]
);

    // Function to compute next state bit y[1]
    function automatic logic next_y1_func(input [2:0] y_state, input w_in);
        begin
            case (y_state)
                3'b000: next_y1_func = 1'b0;           // A(000): next y1=0 regardless w
                3'b001: next_y1_func = 1'b1;           // B(001): next y1=1 regardless w
                3'b010: next_y1_func = w_in ? 1'b1 : 1'b0; // C(010): w=0->E(100) y1=0; w=1->D(011) y1=1
                3'b011: next_y1_func = 1'b0;           // D(011): next y1=0 regardless w
                3'b100: next_y1_func = w_in ? 1'b1 : 1'b0; // E(100): w=0->E(100) y1=0; w=1->D(011) y1=1
                3'b101: next_y1_func = 1'b1;           // F(101): next y1=1 regardless w
                default: next_y1_func = 1'b0;
            endcase
        end
    endfunction

    // Combinational next state bit y[1]
    wire next_y1 = next_y1_func(y, w);

    // Output current y[1]
    assign Y1 = y[1];

endmodule