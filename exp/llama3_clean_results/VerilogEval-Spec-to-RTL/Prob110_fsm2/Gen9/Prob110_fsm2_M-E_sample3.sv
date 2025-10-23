module OffModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k (not used in this module)
    output logic out,    // output
    output logic nextState // signal to transition to ON state
);

    // Asynchronous reset
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            out <= 1'b0;
            nextState <= 1'b0;
        end else begin
            // Synchronous logic
            out <= 1'b0;
            nextState <= j;
        end
    end

endmodule

module OnModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j (not used in this module)
    input        k,      // input k
    output logic out,    // output
    output logic nextState // signal to transition to OFF state
);

    // Asynchronous reset
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            out <= 1'b0;
            nextState <= 1'b0;
        end else begin
            // Synchronous logic
            out <= 1'b1;
            nextState <= k;
        end
    end

endmodule

module TopModule(
    input        clk,    // clock
    input        areset, // asynchronous reset
    input        j,      // input j
    input        k,      // input k
    output logic out     // output
);

    logic offOut;
    logic offNextState;
    logic onOut;
    logic onNextState;
    logic currentState; // 1 for ON, 0 for OFF

    OffModule offModule(
        .clk(clk),
        .areset(areset),
        .j(j),
        .k(k),
        .out(offOut),
        .nextState(offNextState)
    );

    OnModule onModule(
        .clk(clk),
        .areset(areset),
        .j(j),
        .k(k),
        .out(onOut),
        .nextState(onNextState)
    );

    // State register
    always @(posedge areset or posedge clk) begin
        if (areset) begin
            currentState <= 1'b0;
        end else begin
            if (currentState == 1'b0 && offNextState) begin
                currentState <= 1'b1;
            end else if (currentState == 1'b1 && onNextState) begin
                currentState <= 1'b0;
            end
        end
    end

    // Output multiplexer
    assign out = (currentState == 1'b0) ? offOut : onOut;

endmodule