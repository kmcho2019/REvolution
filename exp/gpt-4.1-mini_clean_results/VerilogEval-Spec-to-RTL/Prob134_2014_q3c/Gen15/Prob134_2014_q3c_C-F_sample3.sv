module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,      // asynchronous present state input (ignored internally for FSM operation)
    output       Y0,
    output       z
);

    // Internal registered present state
    reg [2:0] state;

    // Internal next state signals
    wire ns2, ns1, ns0;
    wire [2:0] next_state;

    // Decode current registered state into one-hot signals
    wire s000 = (state == 3'b000);
    wire s001 = (state == 3'b001);
    wire s010 = (state == 3'b010);
    wire s011 = (state == 3'b011);
    wire s100 = (state == 3'b100);

    // Next state bit 2 (ns2) logic from fused optimized expressions:
    // ns2 = 1 when (state=001 and x=1) or (state=100 and x=1)
    assign ns2 = (s001 & x) | (s100 & x);

    // Next state bit 1 (ns1) logic:
    // ns1=1 when (state=010 & x=0) or (state=011 & x=1) or (state=100 & x=0)
    assign ns1 = (s010 & ~x) | (s011 & x) | (s100 & ~x);

    // Next state bit 0 (ns0) logic:
    // ns0 is x when state is 000 or 010, else ~x for other valid states
    assign ns0 = ((s000 | s010) & x) | (~(s000 | s010) & ~x);

    assign next_state = {ns2, ns1, ns0};

    // Output z is combinational from present registered state:
    // z=1 when state=011 or state=100
    assign z = s011 | s100;

    // Output Y0 is bit 0 of next state
    assign Y0 = next_state[0];

    // Synchronous state update on clk
    always @(posedge clk) begin
        // Update state synchronously
        // For safety, reset illegal states to 000 if needed
        if ( (state > 3'b100) ) 
            state <= 3'b000;
        else
            state <= next_state;
    end

endmodule