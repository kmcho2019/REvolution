module TopModule(
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// State encoding
localparam [2:0]
    A  = 3'd0, // reset state
    B  = 3'd1, // f=1 one cycle after reset release
    C1 = 3'd2, // waiting for x=1 (start sequence)
    C2 = 3'd3, // waiting for x=0 after x=1 detected
    C3 = 3'd4, // waiting for x=1 after 1,0 detected
    D  = 3'd5, // g=1, monitor y up to 2 cycles
    E  = 3'd6, // permanent g=1 success
    F  = 3'd7; // permanent g=0 failure

reg [2:0] state, next_state;
reg [1:0] d_count; // counter for 2-cycle monitoring in D

// State and counter sequential logic
always @(posedge clk) begin
    if (!resetn) begin
        state   <= A;
        d_count <= 2'd0;
    end else begin
        state <= next_state;
        if (state == D)
            d_count <= d_count + 1'b1;
        else
            d_count <= 2'd0;
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold
    
    case(state)
        A: begin
            // Wait for reset release
            if (resetn)
                next_state = B;
        end

        B: begin
            // One cycle of f=1 done, start sequence detection
            next_state = C1;
        end

        C1: begin
            // Waiting for x=1 to start sequence
            if (x == 1'b1)
                next_state = C2;
            else
                next_state = C1;
        end

        C2: begin
            // Waiting for x=0 after x=1 detected
            if (x == 1'b0)
                next_state = C3;
            else if (x == 1'b1)
                // still waiting for 0, stay here
                next_state = C2;
            // no other x values possible
        end

        C3: begin
            // Waiting for x=1 to complete sequence 1,0,1
            if (x == 1'b1)
                next_state = D;
            else if (x == 1'b0)
                // sequence failed, restart looking for x=1
                next_state = C1;
        end

        D: begin
            // g=1 and monitoring y for up to 2 cycles
            if (y == 1'b1)
                next_state = E; // success: permanent g=1
            else if (d_count == 2'd1) 
                // d_count counts starting at 0 on entry,
                // after 2 cycles (d_count==1 means one cycle completed),
                // next cycle (d_count==2) is terminal failure
                // But counter increments on each clk, so we wait d_count<2 cycles
                next_state = F; // failure: permanent g=0
            else
                next_state = D; // continue monitoring
        end

        E: begin
            // permanent success g=1
            next_state = E;
        end

        F: begin
            // permanent failure g=0
            next_state = F;
        end

        default: next_state = A;
    endcase
end

// Output logic: f and g outputs registered on clock, driven by current state
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        // f=1 for exactly one cycle in state B, else 0
        f <= (state == B) ? 1'b1 : 1'b0;

        // g=1 in D and E; 0 otherwise
        if (state == D || state == E)
            g <= 1'b1;
        else
            g <= 1'b0;
    end
end

endmodule