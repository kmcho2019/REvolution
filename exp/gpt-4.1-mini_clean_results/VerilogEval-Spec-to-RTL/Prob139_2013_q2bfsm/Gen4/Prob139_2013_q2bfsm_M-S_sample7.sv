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
    B  = 3'd1, // f=1 pulse after reset release
    C1 = 3'd2, // wait x=1 (start sequence)
    C2 = 3'd3, // wait x=0 (second step)
    C3 = 3'd4, // wait x=1 (third step)
    D  = 3'd5, // g=1 and monitor y for up to 2 cycles
    E  = 3'd6, // permanent success (g=1)
    F  = 3'd7; // permanent failure (g=0)

reg [2:0] state, next_state;
reg [1:0] d_count; // count cycles in D

// Sequential state and counter update
always @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        d_count <= 2'd0;
    end else begin
        // If entering D reset d_count, else increment if in D
        if (state != D && next_state == D)
            d_count <= 2'd0;
        else if (state == D)
            d_count <= d_count + 1'b1;
        else
            d_count <= 2'd0;

        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (state)
        A: begin
            // Hold in reset state while resetn==0, else go to B
            if (resetn)
                next_state = B;
        end
        B: begin
            // f=1 one cycle, then go to C1 to start x sequence detection
            next_state = C1;
        end
        C1: begin
            // Wait for x=1 to progress
            if (x == 1'b1)
                next_state = C2;
            else
                next_state = C1;
        end
        C2: begin
            // Wait for x=0
            if (x == 1'b0)
                next_state = C3;
            else if (x == 1'b1)
                next_state = C2; // keep waiting for 0, allow repeated 1's
            else
                next_state = C2; // default
        end
        C3: begin
            // Wait for x=1 to complete sequence
            if (x == 1'b1)
                next_state = D;
            else if (x == 1'b0)
                next_state = C1; // restart sequence detection
            else
                next_state = C1;
        end
        D: begin
            // g=1, monitor y for up to 2 cycles
            if (y == 1'b1)
                next_state = E; // success
            else if (d_count == 2)
                next_state = F; // failure after 2 cycles without y=1
            else
                next_state = D;
        end
        E: begin
            // Permanent success, stay here
            next_state = E;
        end
        F: begin
            // Permanent failure, stay here
            next_state = F;
        end
        default: next_state = A;
    endcase
end

// Output logic (registered)
always @(posedge clk) begin
    if (!resetn) begin
        f <= 1'b0;
        g <= 1'b0;
    end else begin
        f <= (state == B) ? 1'b1 : 1'b0;
        g <= (state == D || state == E) ? 1'b1 : 1'b0;
    end
end

endmodule