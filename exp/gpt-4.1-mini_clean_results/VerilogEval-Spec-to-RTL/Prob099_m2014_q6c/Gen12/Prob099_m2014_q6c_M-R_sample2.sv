module TopModule(
    input  [5:0] y,  // one-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output reg   Y2, // next-state bit for B (y[1])
    output reg   Y4  // next-state bit for D (y[3])
);

    always @(*) begin
        // Default outputs
        Y2 = 1'b0;
        Y4 = 1'b0;

        // Decode current one-hot state and input w to determine next states
        casez ({y, w})
            // State A (000001), input w=0 or 1
            {6'b000001, 1'b0}: begin
                // A --0--> B
                Y2 = 1'b1; // next state B
                Y4 = 1'b0;
            end
            {6'b000001, 1'b1}: begin
                // A --1--> A (no Y2 or Y4)
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
            // State B (000010)
            {6'b000010, 1'b0}: begin
                // B --0--> C (no Y2 or Y4)
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
            {6'b000010, 1'b1}: begin
                // B --1--> D
                Y2 = 1'b0;
                Y4 = 1'b1; // next state D
            end
            // State C (000100)
            {6'b000100, 1'b0}: begin
                // C --0--> E (no Y2 or Y4)
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
            {6'b000100, 1'b1}: begin
                // C --1--> D
                Y2 = 1'b0;
                Y4 = 1'b1;
            end
            // State D (001000)
            {6'b001000, 1'b0}: begin
                // D --0--> F (no Y2 or Y4)
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
            {6'b001000, 1'b1}: begin
                // D --1--> A (no Y2 or Y4)
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
            // State E (010000)
            {6'b010000, 1'b0}: begin
                // E --0--> E (no Y2 or Y4)
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
            {6'b010000, 1'b1}: begin
                // E --1--> D
                Y2 = 1'b0;
                Y4 = 1'b1;
            end
            // State F (100000)
            {6'b100000, 1'b0}: begin
                // F --0--> C (no Y2 or Y4)
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
            {6'b100000, 1'b1}: begin
                // F --1--> D
                Y2 = 1'b0;
                Y4 = 1'b1;
            end
            default: begin
                Y2 = 1'b0;
                Y4 = 1'b0;
            end
        endcase
    end

endmodule