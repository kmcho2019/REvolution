module TopModule(
    input        clk,
    input  [2:0] y_init, // initial state input
    input        w,
    output       Y1
);

    reg [2:0] y;      // current state register
    reg       init_done;

    // On reset (init_done=0), load initial state y_init
    // After that, FSM progresses on clk rising edge
    always @(posedge clk) begin
        if (!init_done) begin
            y <= y_init;      // initialize FSM state
            init_done <= 1'b1;
        end else begin
            // Compute next state y[1] only, keep other bits stable
            case (y)
                3'b000: y[1] <= 1'b0;               // A -> next y[1]=0
                3'b001: y[1] <= 1'b1;               // B -> next y[1]=1
                3'b010: y[1] <= w ? 1'b1 : 1'b0;   // C -> next y[1]=w
                3'b011: y[1] <= 1'b0;               // D -> next y[1]=0
                3'b100: y[1] <= w ? 1'b1 : 1'b0;   // E -> next y[1]=w
                3'b101: y[1] <= 1'b1;               // F -> next y[1]=1
                default: y[1] <= 1'b0;
            endcase
            // y[0] and y[2] remain the same (for simplicity)
            // Alternative: y could be fully updated if desired
        end
    end

    assign Y1 = y[1];

endmodule